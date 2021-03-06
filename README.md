# elm-spa-boilerplate

* Demo http://elm-spa-boilerplate.guupa.com/
* Article https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2

## Characteristics

* Use of pushState navigation using forward slash “/” as path separator
* List of pages in the configuration, easy to add or remove them
* Implementation of localStorage through ports
* Example of Ajax request
* Update of the Title and Meta Description of the page for [Search Engine Optimisation (SEO)](https://medium.com/@l.mugnaini/spa-and-seo-is-googlebot-able-to-render-a-single-page-application-1f74e706ab11)
* Webpack environment (based on https://github.com/halfzebra/create-elm-app)
* [Experimental Built-in Living Style Guide generator](https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522) base on stateless components ([Example](http://elm-spa-boilerplate.surge.sh/styleguide)).
* Sitemap ([Example](http://elm-spa-boilerplate.surge.sh/sitemap))
* Transition between pages

## Usage

If you don’t have Elm yet:
```
$ npm install -g elm
```
If you don’t have create-elm-app yet:
```
$ npm install -g create-elm-app
```
then
```
$ git clone https://github.com/lucamug/elm-spa-boilerplate myproject
$ cd myproject
$ rm -rf .git    # To remove the boilerplate repo, on Windows:
                 # rmdir .git /s /q
$ elm-app start  # To start the local server
```
Then access http://localhost:3000/, and everything should work.

Open the code, in `src`, and poke around!

To build the production version:
```
$ elm-app build
```
The production version is built in build/

## Deploy the app in Surge

Github doesn’t support SPA yet. If you want to check your app in production you can use Surge.

If you don’t have Surge yet
```
$ npm install -g surge
```
then:

```
$ elm-app build
$ mv build/index.html build/200.html
$ surge build myproject.surge.sh
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
```

## Links

http://package.elm-lang.org/packages/mdgriffith/stylish-elephants/4.0.0/
http://package.elm-lang.org/packages/mdgriffith/style-elements/4.2.1/

https://github.com/mdgriffith/stylish-elephants
https://github.com/mdgriffith/style-elements

https://mdgriffith.gitbooks.io/style-elements/content/

https://css-tricks.com/snippets/css/a-guide-to-flexbox/

https://app.netlify.com/

## Lines of code

```
$ cloc src > loc.txt
```

```
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
Elm                              9            419             66           1543
JavaScript                       2             15             27            107
-------------------------------------------------------------------------------
SUM:                            11            434             93           1650
-------------------------------------------------------------------------------
```
