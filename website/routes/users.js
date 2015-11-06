var express = require('express');
var router = express.Router();

var mysql = require('mysql');
var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'root',
    password : 'klaus',
    database : 'koch-rezepte'
});
connection.connect();


function getData(res) {
    connection.query('SELECT * from rezept', function (err, rows, fields) {
        if (err) {
            console.log(err);
            throw err;
        }
        var data = [];
        for( var i in rows) {
            data.push( { id : rows[i].id, desc : rows[i].description } );
        }
        var complData = { title: "Content", list: data };
        console.log(complData);
        res.render('dbonerecord', complData );
    });
    return ;
}

/* GET users listing. */
router.get('/', function(req, res, next) {
    var rc = getData(res);    
});

module.exports = router;
