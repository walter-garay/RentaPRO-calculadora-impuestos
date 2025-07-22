import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

import Components from 'unplugin-vue-components/vite';
import { AntDesignVueResolver } from 'unplugin-vue-components/resolvers';

const isProduction = process.env.NODE_ENV === 'production';

export default defineConfig({
    base: isProduction ? 'https://rentapro.onrender.com/build/' : '/build/',
    plugins: [
        laravel({
            input: 'resources/js/app.js',
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
        Components({
            resolvers: [
                AntDesignVueResolver({
                importStyle: false,
                }),
            ],
        }),
    ],
});
