function displayRoute(res) {

}

$(".button > button").click(() => {
    let sp = $("#start-vid").val(),
        ep = $("#end-vid").val();

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