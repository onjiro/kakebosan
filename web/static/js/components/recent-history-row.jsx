import React from "react";
import moment from "moment";
import _ from "lodash";

export default React.createClass({
  debits() {
    return _(this.props.data.entries || []).filter((e) => e.side_id == 1);
  },
  credits() {
    return _(this.props.data.entries || []).filter((e) => e.side_id == 2);
  },
  debitItems() {
    return this.debits(this.props.data).reduce((memo, e) => memo + e.item.name, '');
  },
  creditItems() {
    return this.credits(this.props.data).reduce((memo, e) => memo + e.item.name, '');
  },
  debitSum() {
    return this.debits(this.props.data).reduce((memo, e) => memo + e.amount, 0);
  },
  creditSum() {
    return this.credits(this.props.data).reduce((memo, e) => memo + e.amount, 0);
  },
  showDetails() {
    this.props.openEditModal(this.props.data);
  },
  render() {
    return (
      <tr onClick={this.showDetails}>
        <td>{moment(this.props.data.date).format('YYYY-MM-DD')}</td>
        <td>{this.debitItems(this.props.data)}</td>
        <td className="hidden-xs">&yen;{this.debitSum(this.props.data)}</td>
        <td>{this.creditItems(this.props.data)}</td>
        <td>&yen;{this.creditSum(this.props.data)}</td>
      </tr>
    );
  }
});
