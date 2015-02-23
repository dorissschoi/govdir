#--Comment: 
#--URL: http://tel.directory.gov.hk/0141011011_CHI.html?accept_disclaimer=yes
#--Proxy authenticate: http://username:password@proxy2.scig.gov.hk:8080
#
exports.getdata = getdata = (dataURL, callback) ->
  env = require("govdirenv")
  http = require("http")
  cheerio = require("cheerio")
  log4js = require("log4js")
  logger = log4js.getLogger()
  contactArr = []
  cnt = 0
  options =
    timeout: env.getdata_timeout
    host: env.getdata_host
    port: env.getdata_port
    method: env.getdata_method
    path: env.getdata_url1 + dataURL + env.getdata_url2

  console.log "options.timeout.." + options.timeout	
  console.log "options.host.." + options.host
  console.log "options.port.." + options.port
  console.log "options.path.." + options.path
  
  #console.log options
  req = http.request(options, (res) ->
    res.setEncoding "utf8"
    str = ""
    res.on "data", (chunk) ->
      str += chunk
      console.log chunk
	
    res.on "end", ->
      $ = cheerio.load(str)
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

    res.on "error", (e) ->
      logger.debug "problem with res: " + e.message

  )
  req.on "error", (e) ->
    console.log "problem with req: " + e.message

  req.end()
