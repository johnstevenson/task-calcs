# task-calcs

Explanation and algorithms for task distance optimization in CIVL hang gliding and paragliding competitions.

The formal definition can be found in the Sporting Code, Section 7F (XC Scoring) from https://www.fai.org/civl-documents.

## About

This repo uses the [asciidoc][asciidoc] format to present its information. See [task-calcs.adoc](task-calcs.adoc), which is the data rendered by the Github interface (click the `Raw` button to see plain text).

The document can be output in PDF or HTML formats:

```sh
build.sh pdf
build.sh html

# output is placed in the output directory
```


## Toolchain

Uses the [asciidoctor][asciidoctor] Ruby packages to produce html and pdf output.

1. Install [Ruby][ruby] - on Windows you can use the [RubyInstaller][rubyinstaller] (note that you don't need the Devkit)
2. Run `gem install asciidoctor` to get the main package
3. Run `gem install asciidoctor-pdf` to get the PDF output package

#### Further reading

- [AsciiDoc Writer’s Guide](https://asciidoctor.org/docs/asciidoc-writers-guide/)
- [Asciidoctor User Manual](https://asciidoctor.org/docs/user-manual/)
- [Asciidoctor PDF](https://github.com/asciidoctor/asciidoctor-pdf)
- [Asciidoctor PDF Theming Guide](https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc) 

  [asciidoc]: http://asciidoc.org/
  [asciidoctor]: https://asciidoctor.org/
  [ruby]: https://www.ruby-lang.org/en/
  [rubyinstaller]: https://rubyinstaller.org/
