import React from "react";

export default React.createClass({
  render() {
    return (
      <div className="col-xs-12">
        <a className="btn btn-primary btn-lg btn-block" onClick={this.props.onClick}>
          <span className="glyphicon glyphicon-pencil"></span> {this.props.children}
        </a>
      </div>
    );
  }
});
