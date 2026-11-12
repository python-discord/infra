# Barium
Static viewer for logs from the legacy Modmail bot. Serves pre-rendered logs at `/logs/<key>`
(the original `modmail.pydis.wtf` URLs) and a SQLite index for client-side search.

The image (`ghcr.io/owl-corp/barium`) is private, as it contains the archived logs, and is built
locally from a Modmail export (see the [barium repo](https://github.com/owl-corp/barium)). It needs
no secrets, and is exposed on `modmail.pydis.wtf` through the `modmail-pydis-wtf` route in
`nginx-gateway/routes/service-routes/`.
