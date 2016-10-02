import React from 'react';
import { Router, Route, browserHistory } from 'react-router';

import User from './user';
import Game from './game';

export default () =>
  <Router history={browserHistory}>
    <Route path="/" component={User} />
    <Route path="/game/:id" component={Game} />
  </Router>;
