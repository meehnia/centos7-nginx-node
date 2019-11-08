var express = require("express"),
    app = express(),
    bodyParser = require("body-parser"),
    os = require('os'),
    http = require('http');

//Set view engine to ejs
app.set("view engine", "ejs"); 

//Tell Express where we keep our index.ejs
app.set("views", __dirname + "/views"); 

//Use body-parser
app.use(bodyParser.urlencoded({ extended: false })); 

//Instead of sending Hello World, we render index.ejs
app.get("/", (req, res) => { res.render("index", {
  hostname : os.hostname(),
  app_root : process.cwd(),
  node_version : process.version
});}); 

server = http.createServer(app);
server.listen(8080, () => { console.log("Server online on http://localhost:8080"); });
