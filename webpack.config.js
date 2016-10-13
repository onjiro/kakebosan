var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
module.exports = {
  devtool: "source-map",
  entry: {
    app: ["./web/static/css/app.scss", "./web/static/js/app.jsx"]
  },
  output: {
    path: "./priv/static",
    filename: "js/app.js"
  },
  resolve: {
    modulesDirectories: [ "node_modules", __dirname + "/web/static/js" ],
    extensions: ["", ".js", ".jsx"]
  },
  module: {
    loaders: [{
      test: /\.jsx?$/,
      exclude: /node_modules/,
      loader: ["babel"],
      include: __dirname,
      query: {
        presets: ["react", "es2015"]
      }
    }, {
      test: /\.css$/,
      loader: ExtractTextPlugin.extract("style", "css")
    }, {
      test: /\.scss$/,
      loader: ExtractTextPlugin.extract("style", "css!sass?includePaths[]=" + __dirname +  "/node_modules")
    }]
  },
  plugins: [
    new ExtractTextPlugin("css/app.css"),
    new CopyWebpackPlugin([{ from: "./web/static/assets" }]),
    new CopyWebpackPlugin([{ from: "./node_modules/bootstrap/dist" }])
  ]
};
