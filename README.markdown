
Can we embed Djula templates in a self-contained binary?

https://github.com/mmontone/djula/issues/79

Eval src/app.lisp or simply run

    make run

this compiles the templates defined in the .asd with the new method
and it exposes the Hunchentoot server on port 6789.

Run the binary produced in `bin/`

and access http://localhost:6789/ and http://localhost:6789/admin (to
properly test in "real" conditions, delete or rename the
`src/templates/` directory).

The template admin.html "extends" base.html (that was Djula's initial difficulty).

Status: progress is made, stay tuned…

**Confirmed**! \o/ 🎉

Next: ~~merge in Djula…~~ patch merged upstream, [with documentation !](https://mmontone.github.io/djula/djula/Deployment.html#Deployment).
