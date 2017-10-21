import React from "react";
export default React.createClass({
  getInitialState() {
    return {
      inventories: []
    };
  },
  componentDidMount() {
    this.loadInventories();
  },
  loadInventories() {
    $.ajax('api/inventories', { dataType: 'json', data: {
      kind: [1, 3]
    }}).then((res) => {
      this.setState({inventories: res.data});
    }, (err) => {
      console.error(err);
    });
  },
  render() {
    var list = this.state.inventories.map((inventory) => (
      <tr>
        <td>{inventory.item.name}</td>
        <td>{inventory.item.kind.name}</td>
        <td>{inventory.item.description}</td>
        <td>{inventory.amount}</td>
        <td><a className="btn btn-default"><span className="glyphicon glyphicon-pen"></span> 棚卸額登録</a></td>
      </tr>
    ));

    return (
      <div>
        <h4>棚卸し</h4>
        <table className="table">
          <thead>
            <tr>
              <th>科目名</th>
              <th>分類</th>
              <th>説明</th>
              <th>残高</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            {list}
          </tbody>
        </table>
      </div>
    );
  }
});
