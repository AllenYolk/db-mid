function displayVideo(res) {
    let liked = res[2], faved = res[3],
        vid = res[1][0][1],
        section = res[1][0][2],
        title = res[1][0][3],
        t = res[1][0][5],
        require_vip = res[1][0][6],
        iframe_url = res[1][0][7],
        watched_cnt = res[1][0][8],
        liked_cnt = res[1][0][9],
        faved_cnt = res[1][0][10],
        comment_cnt = res[1][0][11],
        publisher_name = res[1][0][12],
        vip = res[0][3],
        comments = res[4],
        related_video = res[5];
    
    if (watched_cnt === null)
        watched_cnt = 0;
    if (liked_cnt === null)
        liked_cnt = 0;
    if (faved_cnt === null)
        faved_cnt = 0;
    if (comment_cnt === null)
        comment_cnt = 0;

    if(require_vip===1 && vip===0) {
        alert("Only vip users can watch this video!!!")
        return;
    }

    $(".video-player-wrapper").html(
        `
        <iframe src="${iframe_url}" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
        <div class="v-info">
            <div class="v-title"><p>${title}</p></div>
            <div class="v-vid"><p>${vid}</p></div>
            <div class="v-section"><p>${section}</p></div>
            <div class="v-ptime"><p>${t}</p></div>
        </div>
        <div class="v-clickable-info">
            <div class="v-publisher"><p>${publisher_name}</p></div>
            <div class="v-w"><span>观看：</span><span class="num">${watched_cnt}</span></div>
            <div class="v-l"><span>点赞：</span><span class="num">${liked_cnt}</span></div>
            <div class="v-f"><span>收藏：</span><span class="num">${faved_cnt}</span></div>
            <div class="v-c"><span>评论：</span><span class="num">${comment_cnt}</span></div>
        </div>
        <div class="v-related-video">
            <h2>相关视频：</h2>
        </div>
        `
    )

    let i = 0;
    for (let r of related_video) {
        $(".v-related-video").append(
            `
            <div class="related-video">
                <div class="rv-vid">${r[0]}</div>
                <div class="rv-title">${r[1]}</div>
            </div>
            `
        )
        i = i+1;
        if(i>=5)
            break;
    }
    
    $(".comment-wrapper").empty();
    for (let c of comments){
        $(".comment-wrapper").append(
            `
            <div class="comment">
                <p><strong>${c[0]}:</strong>${c[1]}</p>
            </div>
            `
        )
    }
}

function checkVIDInput(vid) {
    if (vid.search(/^BV[0-9]+$/) !== 0)
        return false;

    return true;
}

function checkUIDInput(uid) {
    if (uid.search(/^[0-9]+$/) !== 0)
        return false;

    return true;
}

function checkUserNameInput(user_name) {
    if (user_name.search(/delete\s+from/) !== -1)
        return false;

    if (user_name.search(/update[\s\S]+set/) !== -1)
        return false;

    if (user_name.search(/insert\s+into/) !== -1)
        return false;

    if (user_name.search(/create\s+table/) !== -1)
        return false;

    if (user_name.search(/drop\s+table/) !== -1)
        return false;

    if (user_name.search(/alter\s+table/) !== -1)
        return false;
    
    return true;
}

$(".button > button").click(() => {
    let user_name = $("#user-name").val(),
        uid = $("#uid").val(),
        vid = $("#vid").val();

    if (!checkUIDInput(uid)) {
        alert("Wrong uid format!!!")
        return;
    }

    if (!checkUserNameInput(user_name)){
        alert("想搞事情？")
        return;
    }

    if(!checkVIDInput(vid)) {
        alert("Wrong vid format!!!");
        return;
    }

    const d = {
        user_name, uid, vid
    }
    console.log(d);

    $.get(
        url = "/mysql-query/video",
        data = d,
        callback = (res) => {
            console.log(res);
            if(res.error === undefined) {
                displayVideo(res);
            }
            else {
                alert(res.error);
            }
        }
    )
})

$("body").on("click", ".v-w", function(){
    let user_name = $("#user-name").val(),
    uid = $("#uid").val(),
    vid = $("#vid").val();

    if (!checkUIDInput(uid)) {
        alert("Wrong uid format!!!")
        return;
    }

    if (!checkUserNameInput(user_name)){
        alert("想搞事情？")
        return;
    }

    if(!checkVIDInput(vid)) {
        alert("Wrong vid format!!!");
        return;
    }

    const d = {
        user_name, uid, vid,
        "target": "w"
    }
    console.log(d); 

    $.get(
        url = "/mysql-query/add-rec",
        data = d,
        callback = (res) => {
            console.log(res);
            alert(res);
            if (res.substring(0, 14) == "Successfully i") {
                $(".v-w > .num").text(
                    parseInt($(".v-w > .num").text())+1+""
                )
                }
            else{
                $(".v-w > .num").text(
                    parseInt($(".v-w > .num").text())-1+""
                )    
            } 
        }
    )
})

$("body").on("click", ".v-l", function(){
    let user_name = $("#user-name").val(),
    uid = $("#uid").val(),
    vid = $("#vid").val();
    
    if (!checkUIDInput(uid)) {
        alert("Wrong uid format!!!")
        return;
    }

    if (!checkUserNameInput(user_name)){
        alert("想搞事情？")
        return;
    }

    if(!checkVIDInput(vid)) {
        alert("Wrong vid format!!!");
        return;
    }

    const d = {
        user_name, uid, vid,
        "target": "l"
    }
    console.log(d); 

    $.get(
        url = "/mysql-query/add-rec",
        data = d,
        callback = (res) => {
            console.log(res);
            alert(res);
            if (res.substring(0, 14) == "Successfully i") {
                $(".v-l > .num").text(
                    parseInt($(".v-l > .num").text())+1+""
                )
                }
            else{
                $(".v-l > .num").text(
                    parseInt($(".v-l > .num").text())-1+""
                )    
            } 
        }
    )
})

$("body").on("click", ".v-f", function(){
    let user_name = $("#user-name").val(),
    uid = $("#uid").val(),
    vid = $("#vid").val();

    if (!checkUIDInput(uid)) {
        alert("Wrong uid format!!!")
        return;
    }

    if (!checkUserNameInput(user_name)){
        alert("想搞事情？")
        return;
    }

    if(!checkVIDInput(vid)) {
        alert("Wrong vid format!!!");
        return;
    }

    const d = {
        user_name, uid, vid,
        "target": "f"
    }
    console.log(d); 

    $.get(
        url = "/mysql-query/add-rec",
        data = d,
        callback = (res) => {
            console.log(res);
            alert(res);
            if (res.substring(0, 14) == "Successfully i") {
                $(".v-f > .num").text(
                    parseInt($(".v-f > .num").text())+1+""
                )
                }
            else{
                $(".v-f > .num").text(
                    parseInt($(".v-f > .num").text())-1+""
                )    
            } 
        }
    )
})

$("body").on("click", ".v-publisher", function(){
    let user_name = $("#user-name").val(),
    uid = $("#uid").val(),
    vid = $("#vid").val();

    if (!checkUIDInput(uid)) {
        alert("Wrong uid format!!!")
        return;
    }

    if (!checkUserNameInput(user_name)){
        alert("想搞事情？")
        return;
    }

    if(!checkVIDInput(vid)) {
        alert("Wrong vid format!!!");
        return;
    }

    const d = {
        user_name, uid, vid,
        "target": "u",
        "target_uid": $(".v-publisher > p").text()
    }
    console.log(d); 

    $.get(
        url = "/mysql-query/add-rec",
        data = d,
        callback = (res) => {
            console.log(res);
            alert(res);
        }
    )
})