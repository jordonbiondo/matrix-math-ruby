import Route from '@ember/routing/route';

export default Route.extend({
    async model() {
        const output = await new Promise((ok) => {
            setTimeout(() => {
                ok([1, 2, 3, 4]);
            }, 1000);
        });
        return output;
    }
});
