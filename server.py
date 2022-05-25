from tracemalloc import start
from flask import Flask, render_template, jsonify, request
import pymysql
from pprint import pprint


app = Flask(__name__)


def conn_db(host="localhost", user="root", password="yifan001", database="db_mid"):
    db = pymysql.connect(
        host = host,
        user = user,
        password = password,
        database = database
    )
    cursor = db.cursor()
    return db, cursor


@app.route("/")
def getRoot():
    print("yeah")
    return render_template("index.html")


@app.route("/<name>.html")
def getHTML(name):
    return render_template(f"{name}.html")


@app.route("/mysql-query/homepage")
def getHomepageResponse():
    db, cursor = conn_db()
    sec = request.args.get("section")

    where_clause = "" if sec=="全站" else f"where section_name='{sec}'"

    sql = f"""
    select * 
    from video natural left outer join view_video_data 
    {where_clause} 
    order by watched_count desc, comment_count desc, faved_count desc, liked_count desc;
    """
    cursor.execute(sql)
    res = cursor.fetchall()
    db.close()
    return jsonify(res)


@app.route("/mysql-query/video")
def getVideoResponse():
    db, cursor = conn_db()
    user_name = request.args.get("user_name")
    uid = request.args.get("uid")
    vid = request.args.get("vid")

    sql1 = f"""
    select * from website_user
    where user_id = {uid} and user_name = '{user_name}';
    """
    cursor.execute(sql1)
    res1 = list(cursor.fetchall())
    if len(res1) == 0: # uid mismatch user_name
        return jsonify({"error": "Mistakes in user information!"})

    sql2 = f"""
    select *
    from video natural left outer join view_video_data 
    natural join user_publish_video natural join website_user
    where video_id = '{vid}';
    """
    cursor.execute(sql2)
    res2 = [list(cursor.fetchall())]
    if len(res2) == 0:
        return jsonify({"error": "Video information error!"})
    
    cursor.execute(f"""
    select * from user_like_video
    where user_id={uid} and video_id='{vid}';
    """)
    res3 = len(cursor.fetchall())
    cursor.execute(f"""
    select * from user_add2fav_video
    where user_id={uid} and video_id='{vid}';
    """)
    res4 = len(cursor.fetchall())
    cursor.execute(f"""
    select user_name, comment_text
    from video_comment natural join website_user
    where video_id='{vid}'
    order by comment_seqnum asc;
    """)
    res5 = list(cursor.fetchall())
    cursor.execute(f"""
    select related_video_id, video_title
    from related_video join video on related_video_id = video_id
    where main_video_id = '{vid}';
    """)
    res6 = list(cursor.fetchall())

    res2 = res1+res2
    res2.append(res3)
    res2.append(res4)
    res2 = res2+[res5]+[res6]
    return jsonify(res2)

target_dict = {
    "w": "user_watch_video", 
    "l": "user_like_video", 
    "f": "user_add2fav_video",
    "u": "follow_record"
}

@app.route("/mysql-query/add-rec")
def addRecords():
    db, cursor = conn_db()
    user_name = request.args.get("user_name")
    uid = request.args.get("uid")
    vid = request.args.get("vid")
    target_uid = None
    target = request.args.get("target")
    if target == "u":
        target_uid = request.args.get("target_uid")
        cursor.execute(f"select user_id from website_user where user_name='{target_uid}';")
        target_uid = cursor.fetchall()[0][0]
        print(isinstance(target_uid, int))
    target = target_dict[target]


    if target == "follow_record":
        sql = f"""
        select * from {target} where followed_id = {target_uid} and follower_id = {uid};
        """
    else:
        sql = f"""
        select * from {target}
        where video_id = '{vid}' and user_id = {uid};
        """
    cursor.execute(sql)

    op = "delete"
    if len(cursor.fetchall()) == 0:
        op = "insert into"
    if target == target_dict["w"]:
        op = "insert into"

    if op == "delete":
        if target == "follow_record":
            sql2 = f"""
            delete from {target}
            where followed_id = {target_uid} and follower_id = {uid};
            """
        else:
            sql2 = f"""
            delete from {target}
            where video_id = '{vid}' and user_id = {uid};
            """
    else:
        if target == "follow_record":
            sql2 = f"""
            call follow({uid}, {target_uid});
            """
        elif target == "user_watch_video":
            sql2 = f"""
            call watch('{vid}', {uid});
            """
        else:
            sql2 = f"""
            insert into {target} values
            ({uid}, '{vid}')
            """

    cursor.execute(sql2)
    db.commit()
    return f"Successfully {op} {target}"


@app.route("/mysql-query/user")
def getUser():
    db, cursor = conn_db()
    user_name = request.args.get("user_name")
    uid = request.args.get("uid")

    if uid == "":
        sql = f"select * from website_user where user_name='{user_name}';"
    else:
        sql = f"select * from website_user where user_id={uid} and user_name='{user_name}';"
    cursor.execute(sql)
    res1 = list(cursor.fetchall())
    if len(res1) == 0:
        return jsonify({"error": "User information error!"})
    if uid == "":
        uid = res1[0][0]

    sql = f"""
    select count(*) from follow_record
    where followed_id = {uid};
    """
    cursor.execute(sql)
    res2 = list(cursor.fetchall())

    sql = f"""
    select count(*) from follow_record
    where follower_id = {uid};
    """
    cursor.execute(sql)
    res3 = list(cursor.fetchall())

    sql= f"""
    select * 
    from user_publish_video natural join video natural left outer join view_video_data
    where user_id = {uid}
    """
    cursor.execute(sql)
    res4 = list(cursor.fetchall())

    return jsonify(res1+res2+res3+[res4])


@app.route("/mysql-query/routing")
def getRouting():
    db, cursor = conn_db()
    sp = request.args.get("sp")
    ep = request.args.get("ep")

    cursor.execute(f"select * from video where video_id = '{sp}';")
    if(len(cursor.fetchall()) == 0):
        return jsonify({"error": "Starting point's vid is wrong!"})
    cursor.execute(f"select * from video where video_id = '{ep}';")
    if(len(cursor.fetchall()) == 0):
        return jsonify({"error": "End point's vid is wrong!"})

    v = []
    dis = {}
    dd = {}
    cursor.execute(f"select video_id from video")
    for i, vv in enumerate(cursor.fetchall()):
        v.append(vv[0])
        dis[vv[0]] = [i, -1]
        dd[i] = 9999999
    adj = [[0 for i in range(len(v))] for j in range(len(v))]
    cursor.execute(f"select main_video_id, related_video_id from related_video")
    for p in cursor.fetchall():
        adj[dis[p[0]][0]][dis[p[1]][0]] = 1

    start_point = dis[sp][0]
    dd[start_point] = 0;
    dis[sp][1] = start_point
    while True:
        ddd = sorted(dd.items(), key = lambda x: x[1])
        new_seq, new_dis = ddd[0]
        flag = False
        for seq, old_dis in ddd:
            if adj[new_seq][seq] == 1 and new_dis+1 < old_dis:
                dd[seq] = new_dis+1
                dis[v[seq]][1] = new_seq
                flag = True
        del(dd[new_seq])
        if not flag:
            break

    r = [ep]
    if ep == sp:
        r = [sp]
    elif dis[ep][1] < 0:
        r = []
    else:
        while True:
            now_front = r[len(r)-1]
            new_front_seq = dis[now_front][1]
            r.append(v[new_front_seq])
            if new_front_seq == start_point:
                break
    
    pprint(r)
    pprint(adj)
    pprint(v)
    pprint(dis)

    if len(r) == 0:
        return jsonify({})
    res = []
    r.reverse()
    for vid in r:
        sql = f"""
        select * 
        from video natural left outer join view_video_data 
        where video_id = '{vid}';
        """
        cursor.execute(sql)
        res.append(cursor.fetchone())
    return jsonify(res)



if __name__ == "__main__":
    app.run()