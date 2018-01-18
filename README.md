# elm-spa-boilerplate

* Demo http://elm-spa-boilerplate.surge.sh/
* Article https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2

## Characteristics

* Use of pushState navigation using forward slash “/” as path separator
* List of pages in the configuration, easy to add or remove them
* Implementation of localStorage through ports
* Example of Ajax request
* Update of the Title and Meta Description of the page for [Search Engine Optimisation (SEO)](https://medium.com/@l.mugnaini/spa-and-seo-is-googlebot-able-to-render-a-single-page-application-1f74e706ab11)
* Webpack environment (based on elm-community/elm-webpack-starter)
* [Experimental Built-in Living Style Guide generator](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522) base on stateless components
* Sitemap
* Transition between pages

## Usage

If you don’t have Elm yet:
```
$ npm install -g elm
```
then
```
$ git clone https://github.com/lucamug/elm-spa-boilerplate myproject
$ cd myproject
$ rm -rf .git    # To remove the boilerplate repo, on Windows:
                 # rmdir .git /s /q
$ npm install    # To install the necessary packages
$ npm start      # To start the local server
```
Then access http://localhost:8080/, and everything should work.

Open the code, in src/elm, and poke around!

To build the production version:
```
$ npm run build
```
The production version is built in dist/

## Deploy the app in Surge

Github doesn’t support SPA yet. If you want to check your app in production you can use Surge.

If you don’t have Surge yet
```
$ npm install -g surge   # To install surge if you don't have it
```
then, from myproject folder

```
$ npm run build
$ cd dist
$ mv index.html 200.html
$ surge --domain myproject.surge.sh
```
Other useful Surge commands
```
$ surge list
$ surge teardown myproject.surge.sh
```

## To create a new repository

From myproject foder:
```
$ git init
$ git add .
$ git commit -m 'first commit'
