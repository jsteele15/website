/*
//this code gets the button of the fullscreen and then makes its window fullscreen
document.getElementById("f_button").addEventListener("click", function(){
    var element = document.getElementById("gameContainer");

    if (element.requestFullscreen) {

        element.requestFullscreen();

    } else if (element.mozRequestFullScreen) {

        element.mozRequestFullScreen();

    } else if (element.webkitRequestFullscreen) {

        element.webkitRequestFullscreen();

    } else if (element.msRequestFullscreen) {

        element.msRequestFullscreen();

    }
})*/

//this is the code for managing the moveing box of items at the bottom of the screen
//might need a seperate doc tbf
const carouselInner = document.querySelector('.car_inner');
const items = document.querySelectorAll('.car_item');
const totalItems = items.length;

let currentIndex = 0;
function cloneItems() {
    items.forEach(item => {
        const clone = item.cloneNode(true);
        carouselInner.appendChild(clone);
    });
}

cloneItems();

document.querySelectorAll('.movingImage').forEach(image => {
    image.addEventListener('click', function() {
        console.log('Image clicked!');
    });
});