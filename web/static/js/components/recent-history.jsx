import React from "react";
import RecentHistoryRow from "./recent-history-row";
import moment from "moment";

export default React.createClass({
  toBeLoadedRange() {
    var to   = moment(this.props.dateFrom).subtract(1, 'days').format("YYYY/MM/DD");
    var from = moment(this.props.dateFrom).subtract(1, 'month').format("YYYY/MM/DD");
    return `${to} 〜 ${from}`;
  },
  loadFollowingHistories(e) {
    e.preventDefault();
    this.props.loadFollowingHistories();
  },
  render() {
    var list = this.props.data.map((transaction) => (
      <RecentHistoryRow key={transaction.id} data={transaction}
                        deleteTransaction={this.props.deleteTransaction}/>
    ));

    return (
      <div className="col-xs-12">
        <h4>直近７日間の履歴</h4>
        <section className="history row" style={{ minHeight: '320px'}}>
          <table className="table">
            <thead>
              <tr>
                <th>日付</th>
                <th>借方科目</th>
                <th className="amount hidden-xs">借方金額</th>
                <th>貸方科目</th>
                <th className="amount">貸方金額</th>
                <th>{/* controls */}</th>
              </tr>
            </thead>
            <tbody>
              { list }
            </tbody>
          </table>
          <div className="col-xs-12">
            <a className="btn btn-lg btn-default btn-block" href="#" onClick={this.loadFollowingHistories}>
              <span className="glyphicon glyphicon-download"></span>続き({this.toBeLoadedRange()})
            </a>
          </div>
        </section>
      </div>
    );
  }
});
