// pull in desired CSS/SASS files
require('./styles/normalize.css');
require('./styles/main.sass');


// var $ = jQuery = require( '../../node_modules/jquery/dist/jquery.js' );           // <--- remove if jQuery not needed
// require( '../../node_modules/bootstrap-sass/assets/javascripts/bootstrap.js' );   // <--- remove if Bootstrap's JS not needed

(function(window, document) {

    var Elm = require('../elm/Main');

    var 凸 = Elm.Main.fullscreen(localStorage.getItem("spa") || "");

    凸.ports.urlChange.subscribe(function(title) {
        document.body.classList.add("urlChange");
        window.requestAnimationFrame(function() {
            document.title = title;
            document.querySelector('meta[name="description"]').setAttribute("content", title);
            setTimeout(function() {
                document.body.classList.remove("urlChange");
            }, 100)
        });
    });

    凸.ports.storeLocalStorage.subscribe(function(value) {
        localStorage.setItem("spa", value);
    });

    window.addEventListener("storage", function(event) {
        if (event.storageArea === localStorage && event.key === "spa") {
            凸.ports.onLocalStorageChange.send(event.newValue);
        }
    }, false);

})(window, document);
