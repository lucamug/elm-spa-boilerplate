import './main.css';
import {
    Main
} from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const pack = require('../package.json');
const packElm = require('../elm-package.json');

registerServiceWorker();

const elmSpa = Main.fullscreen({
    localStorage: (localStorage.getItem("spa") || ""),
    packVersion: pack.version,
    packElmVersion: packElm.version,
});

elmSpa.ports.urlChange.subscribe(function(title) {
    document.body.classList.add("urlChange");
    setTimeout(function() {
        document.body.classList.remove("urlChange");
    }, 100)
    window.requestAnimationFrame(function() {
        document.title = title;
        document.querySelector('meta[name="description"]').setAttribute("content", title);
    });
});

elmSpa.ports.storeLocalStorage.subscribe(function(value) {
    localStorage.setItem("spa", value);
});

window.addEventListener("storage", function(event) {
    if (event.storageArea === localStorage && event.key === "spa") {
        elmSpa.ports.onLocalStorageChange.send(event.newValue);
    }
}, false);;
