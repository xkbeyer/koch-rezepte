var express = require('express');
var router = express.Router();


function getData(dbcon, res) {
    dbcon.query('SELECT id, name, description from rezept', function (err, rows, fields) {
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

function getIngredients(id, dbcon, res) {
    dbcon.query('SELECT * FROM `koch-rezepte`.ingredients where rezept = ' + dbcon.escape(id), function (err, rows, fields) {
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
    req.dbcon.query(sqlStatement, function (err, rows, fields) {
        if (err) {
            console.log(err);
        }
        res.redirect("/users?ShowRecipe=" + rezeptid);
    });
}

function delIngredient(req, res) {
    var o = JSON.parse(req.query.DoDelIngredient);
    console.log("del ingredient(" + o.id + ", " + o.item + ")");
    var sqlStatement = "select del_ingredient(" + req.dbcon.escape(o.id) + ",'" + o.item + "');";
    req.dbcon.query(sqlStatement, function(err, rows, fields) {
        if( err ) {
            console.log(err);
        } else {
            if (rows.length != 1 ) {
                console.log("Missing return code.");
            } else if (rows[0] != 0) {
                console.log("Returned error code = " + rows[0]);
            }
        }
        res.redirect("/users?ShowRecipe=" + o.id);
    });
}

/* GET users listing. */

router.get('/', function (req, res, next) {
    if (req.query.ShowRecipe) {
        getIngredients(req.query.ShowRecipe, req.dbcon, res);
    } else if (req.query.DoAddIngredient) {
        addIngredient(req, res);
    } else if (req.query.DoDelIngredient) {
        delIngredient(req,res);
    } else {
        var rc = getData(req.dbcon, res);
    }
});


module.exports = router;
