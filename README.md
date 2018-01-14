# elm-spa-boilerplate




# To the the production version

$ npm run server

# To deploy in github

Github doesn't support push-state webserver yet https://github.com/isaacs/github/issues/408

# To deploy in surge, as SPA

$ npm install --global surge

$ npm run build
$ cd dist
$ mv index.html 200.html
$ surge

Useful commands

$ surge --domain elm-spa-boilerplate.surge.sh
$ surge list
$ surge teardown elm-spa-boilerplate.surge.sh


http://elm-spa-boilerplate.surge.sh/

## TODO

- Add spinner to button
- Add automatic labels to input fields
- Add a form
- Server Side Renderin
- PWA

## Other boilerplates

https://github.com/rl-king/elm-hnpwa/tree/master/src
    PWA

https://github.com/zhevron/elm-spa-boilerplate

https://github.com/astroash/elm-spa-boiler-plate
    http://boiler-my-plate.surge.sh/

https://github.com/chrisUsick/elm-spa-boilerplate
    elm-live --output=elm.js src/Main.elm --pushstate --open --debug

https://github.com/chrisUsick/elm-spa-mdl-boilerplate
    elm-live --output=elm.js src/Main.elm --pushstate --open --debug
https://github.com/joaobalsini/elm-spa-starter-app
https://github.com/rtfeldman/elm-spa-example
