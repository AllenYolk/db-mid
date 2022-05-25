function displayRoute(res) {
    let ii = 1, l = res.length;
    for(let row of res) {
        for(let i=7; i<=10; i=i+1) {
            if(row[i] === null)
                row[i] = 0;
        }
        let vid = row[0],
            section = row[1],
            title = row[2],
            t = row[4],
            vip_only = Boolean(row[5]),
            watched = row[7],
            liked = row[8],
            faved = row[9],
            commented = row[10];

        prefix = `第${ii}站`;
        if (ii === 1)
            prefix = "起点站"
        else if (ii === l)
            prefix = "终点站"
        $(".video-list").append(
            $("<div class='homepage-video'></div>").html(
                `<div class='hpvideo-title'><span class="r-prefix">${prefix}：</span>${title}</div>
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
        ii = ii + 1;
    }
}

function checkVIDInput(vid) {
    if (vid.search(/^BV[0-9]+$/) !== 0)
        return false;

    return true;
}

$(".button > button").click(() => {
    $(".video-list").empty()
    let sp = $("#start-vid").val(),
        ep = $("#end-vid").val();

    if(!(checkVIDInput(sp) && checkVIDInput(ep))) {
        alert("Wrong vid format!!!");
        return;
    }

    let d = {sp, ep};
    console.log(d);

    $.get(
        url = "/mysql-query/routing",
        data = d,
        callback = (res) => {
            console.log(res);
            if(res.error === undefined)
                displayRoute(res);
            else
                alert(res.error)
        }
    )
})