
Can we embed Djula templates in a self-contained binary?

https://github.com/mmontone/djula/issues/79

Eval patches.lisp,

then in app.lisp eval the snippet that tries to compile all templates, or simply run

    make run

this tries to compile them with the new method and exposes the Hunchentoot server on port 6789.

Access http://localhost:6789/ and http://localhost:6789/admin

The template admin.html "extends" base.html (Djula initial difficulty).

Status: progress is made, stay tuned…
