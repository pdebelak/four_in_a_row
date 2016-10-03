import React from 'react';
import { browserHistory } from 'react-router';
import qwest from 'qwest';

export default class extends React.Component {
  componentDidMount() {
    qwest.post('/games', {})
      .then((_, response) =>
        browserHistory.push(`/game/${response.game.uuid}?player=${this.props.location.query.player}`)
      );
  }

  render() {
    return null;
  }
}
