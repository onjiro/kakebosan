import React from "react";
import ReactDOM from "react-dom";

export default React.createClass({
  value() {
    return ReactDOM.findDOMNode(this.refs.date).value;
  },
  render() {
    return (
      <div className="input-group">
        <div className="input-group-addon"><span className="glyphicon glyphicon-time"></span></div>
        <input className="form-control" type="date" ref="date"
               value={this.props.value}
               onChange={this.props.onChange} />
      </div>
    );
  }
});
