inputdata = require("./updateContact.coffee")

schedule = require("node-schedule")
rule = new schedule.RecurrenceRule()

j = schedule.scheduleJob(rule, ->
  inputdata.insertdb (contactArr) ->
)  
