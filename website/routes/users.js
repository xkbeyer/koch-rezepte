var express = require('express');
var router = express.Router();

var mysql = require('mysql');
var connection = mysql.createConnection({
    host     : 'localhost',
    user     : 'kochmate',
    password : 'epsilon-signum',
    database : 'koch-rezepte'
});

function getData(res) {
    connection.query('SELECT id, name, description from rezept', function (err, rows, fields) {
        if (err) {
            console.log(err);
            throw err;
        }
        var data = [];
        for( var i in rows) {
            data.push( { id : rows[i].id, name : rows[i].name, desc : rows[i].description } );
        }
        var complData = { title: "Recipes", list: data };
        res.render('dbonerecord', complData );
    });
    return ;
}

function getIngredients(id, res) {
    connection.query('SELECT * FROM `koch-rezepte`.ingredients where rezept = ' + connection.escape(id), function (err, rows, fields) {
        if (err) {
            console.log(err);
            throw err;
        }
        var data = [];
        for (var i in rows) {
            data.push({ id : rows[i].rezept, quantity : rows[i].quantity, unit : rows[i].unit, name : rows[i].name });
        }
        var RezeptName = "Unknown";
        if (data.length) {
            RezeptName = rows[0].rezeptname;
        }
        var complData = { title: RezeptName, RezeptID: id, list: data };
        res.render('listingredients', complData);
    });
    return;
}

function addIngredient(req, res) {
    var o = JSON.parse(req.query.DoAddIngredient);
    var rezeptname = o.name;
    var rezeptid = o.id;
    var sqlStatement = "call add_ingredient('" + rezeptname + "'," + req.query.qty + ",'" + req.query.unit + "','" +  req.query.name + "', @err_code)";
    connection.query(sqlStatement, function (err, rows, fields) {
        if (err) {
            console.log(err);
        } else {
            if (rows.affectedRows == 1) {
            }
        }
        res.redirect("/users?ShowRecipe=" + rezeptid);
    });
}

/* GET users listing. */

router.get('/', function (req, res, next) {
    if (req.query.ShowRecipe) {
        getIngredients(req.query.ShowRecipe, res);
    } else if (req.query.DoAddIngredient) {
        addIngredient(req, res);
    } else {
        var rc = getData(res);
    }

});


module.exports = router;
