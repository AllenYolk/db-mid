function addNewVideoBlock(row) {
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

$(".button > button").click(() => {
    $(".video-list").empty();

    const sec = $("#section-select").val();
    const d = {"section": sec}

    $.get(
        url =  "/mysql-query/homepage",
        data =  d,
        callback = (res) => {
            console.log(res);
            
            let i = 0;
            for (let row of res) {
                addNewVideoBlock(row)

                i = i+1;
                if (i >= 10)
                    break;
            }
        }
    )
})