import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
    location: config.locationType,
    rootURL: config.rootURL
});

Router.map(function() {
    this.route('authenticated', { path: '/' }, function () {
        this.route('home', {path: '/'}, function () {

        });
    });
});

export default Router;
