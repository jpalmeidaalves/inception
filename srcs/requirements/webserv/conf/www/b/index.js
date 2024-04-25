
//if click int restart button, set the h1 to Refresh Me and refresh the page
document.querySelectorAll("button")[0].addEventListener("click", function () {
    document.querySelector("h1").textContent = "Who is lucky today?";
    document.querySelector(".img1").setAttribute("src", "images/dice1.png");
    document.querySelector(".img2").setAttribute("src", "images/dice1.png");
});

document.querySelectorAll("button")[1].addEventListener("click", function () {
    var p1 = Math.floor(Math.random() * 6) + 1;
    var p2 = Math.floor(Math.random() * 6) + 1;
    var s = "./images/dice" + p1 + ".png";
    document.querySelector("img").setAttribute("src", s);
    document.querySelector(".img2").setAttribute("src", "images/dice" + p2 + ".png");
    if (p1 > p2) {
        document.querySelector("h1").textContent = "🚩 Player 1 Wins!";
    }
    else if (p1 < p2) {
        document.querySelector("h1").textContent = "Player 2 Wins! 🚩";
    } else {
        document.querySelector("h1").textContent = "Draw!";
    }
});