import React from "react";
import ReactDOM from "react-dom";
import Select from "react-select";

export default React.createClass({
  handleItemChange(selected) {
    this.props.onChange(_.extend(this.props.data, { item: { id: selected.value } }));
  },
  handleAmountChange(event) {
    this.props.onChange(_.extend(this.props.data, { amount: Number(ReactDOM.findDOMNode(this.refs.amount).value) }));
  },
  typeLabel(item) {
    switch (item.type_id) {
      case 1: return "資産";
      case 2: return "費用";
      case 3: return "負債";
      case 4: return "資本";
      case 5: return "利益";
      default: return "";
    }
  },
  render() {
    var options = this.props.items.map((item) => new Object({
      label: `${this.typeLabel(item)}:${item.name}`,
      value: item.id
    }));
    return (
      <div className="account-line clearfix">
        <Select className="col-xs-8-form" placeholder="科目"
                options={options} value={this.props.data.item && this.props.data.item.id || null}
                onChange={this.handleItemChange} />
        <input className="form-control col-xs-4-form" placeholder="金額"
               type="number" style={{textAlign: "right"}} value={this.props.data.amount}
               ref="amount" onChange={this.handleAmountChange} />
      </div>
    );
  },
});
