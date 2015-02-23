env = require 'govdirenv'
mongoose = require 'mongoose'

mongoose.connect env.dburl 

userSchema = new mongoose.Schema(
 name:  {type: String, trim: true}
 title: {type: String, trim: true}
 phone: {type: String, trim: true}
 email: {type: String, trim: true}
)
userModel = mongoose.model(env.dbmodel, userSchema)
module.exports = 'userModel': userModel



