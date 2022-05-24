function addNewVideoBlock(row) {
    console.log(row)
    for(let i=8; i<=11; i=i+1) {
        if(row[i] === null)
            row[i] = 0;
    }
    let vid = row[0],
        section = row[2],
        title = row[3],
        t = row[5],
        vip_only = Boolean(row[6]),
        watched = row[8],
        liked = row[9],
        faved = row[10],
        commented = row[11];

    $(".video-list").append(
        $("<div class='homepage-video'></div>").html(
            `<div class='hpvideo-title'>${title}</div>
            <div class="hpvideo-vid">${vid}</div>
            <div class="hpvideo-section">${section}</div>
            <div class="hpvideo-t">${t}</div>
            <div class="hpvideo-vip">need_vip: ${vip_only}</div>
            <div class="hpvideo-watched">观看:${watched}</div>
            <div class="hpvideo-liked">点赞:${liked}</div>
            <div class="hpvideo-faved">收藏:${faved}</div>
            <div class="hpvideo-commented">评论:${commented}</div>` 
        )
    );
}

function displayUser(res) {
    let uid = res[0][0], user_name = res[0][1],
        exp = res[0][2], vip = res[0][3],
        fans = res[1][0], follows = res[2][0],
        pub_videos = res[3];
    

    for(let v of pub_videos) {
        addNewVideoBlock(v);
    }

    let lv = 0;
    if(exp < 200)
        lv = 1;
    else if(exp < 1500)
        lv = 2;
    else if(exp < 4500)
        lv = 3;
    else if(exp < 10800)
        lv = 4;
    else if(exp < 28800)
        lv = 5;
    else
        lv = 6;
    $(".user-info-wrapper").html(
        `<div class="u-uid"><span>UID: ${uid}</span></div>
        <div class="u-name"><span>${user_name}</span></div>
        <div class="u-exp"><span class="lv">LV: ${lv}</span> <span class="ex">[exp: ${exp}]</span></div>
        <div class="u-vip"><span>VIP:${vip}</span></div>
        <div class="u-fans"><p>粉丝数：</p><p>${fans}</p></div>
        <div class="u-follows"><p>关注数：</p><p>${follows}</p></div>`
    )
}

$(".button > button").click(() => {
    $(".user-info-wrapper").empty();
    $(".video-list").empty();
    let user_name = $("#user-name").val(),
        uid = $("#uid").val();

    let d = {
        user_name, uid
    };

    $.get(
        url = "/mysql-query/user",
        data = d,
        callback = (res) => {
            console.log(res);
            if(res.error === undefined)
                displayUser(res);
            else
                alert(res.error);
        }
    )

})