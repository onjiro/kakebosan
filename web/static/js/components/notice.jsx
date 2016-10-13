import React from "react";
export default React.createClass({
  render() {
    return (
      <div className={'alert alert-float alert-' + (this.props.type || 'info')}>
        {this.props.children}
      </div>
    );
  }
});
