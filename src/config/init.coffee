module.exports = ->
  if not process.env.NODE_ENV or process.env.NODE_ENV in ['development', 'test', 'staging']
    process.env.MONGO_CLIENT_WRESTLEDB = process.env.MONGO_CLIENT_WRESTLEDB or "mongodb://localhost/wrestledb" #need to wire local up