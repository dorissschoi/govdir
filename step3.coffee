exports.init = (dataURL, callback) ->
  #console.log 'start get data:'+ dataURL
  request = require('request')
  env = require("govdirenv")
  http = require("http")
  cheerio = require("cheerio")
  log4js = require("log4js")
  logger = log4js.getLogger()
  contactArr = []
  options =
    path: env.getdata_url1 + dataURL + env.getdata_url2
  #console.log options  

  request {
    uri: options.path
    method: 'POST'
  }, (error, response, body) ->
    $ = cheerio.load(body)
    l_name = ""
    l_title = ""
    l_phone = ""
    l_email = ""
    contact = []
    tmp = ""
    $("table.tbl_dept_contact_list tr.row").each ->
      l_name = $(this).find("td:first-child").text()
      l_title = $(this).find("td:nth-child(2)").text()
      l_phone = $(this).find("td:nth-child(3)").text()
      tmp = $(this).find("td:nth-child(4)").text().replace(/var email = \'/g, "")
      tmp = tmp.replace(/\'\;var domain \= \'/g, "@")
      l_email = tmp.replace(/\'\;document\.write\(\'\<a href\=\"mailto\:\' \+ email \+ \'\@\' \+ domain \+ \'\"\>\' \+ email \+ \'\@\' \+ domain \+ \'\<\\\/a\>\'\)\;/g, "")
      contact =
        name: l_name
        title: l_title
        phone: l_phone
        email: l_email
      
      contactArr.push contact
    
    callback contactArr
   