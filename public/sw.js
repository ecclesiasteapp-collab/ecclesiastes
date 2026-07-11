// Ecclesiaste Service Worker for Offline Capabilities
const CACHE_NAME = 'ecclesiaste-cache-v1';

// Key assets to pre-cache on install
const PRECACHE_ASSETS = [
  '/',
  '/index.html',
  '/assets/images/icone.png',
  '/assets/librairie/bible_tob.json'
];

// Install Event: pre-cache critical shell assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('[Service Worker] Pre-caching application shell...');
      return cache.addAll(PRECACHE_ASSETS).then(() => self.skipWaiting());
    })
  );
});

// Activate Event: clean up outdated caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cache) => {
          if (cache !== CACHE_NAME) {
            console.log('[Service Worker] Deleting old cache:', cache);
            return caches.delete(cache);
          }
        })
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch Event: handle offline routing and asset caching
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // We only intercept GET requests
  if (request.method !== 'GET') {
    return;
  }

  // Handle SPA navigation requests (HTML document)
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((response) => {
          // If online, save/update the navigation response in cache
          const copy = response.clone();
          caches.open(CACHE_NAME).then((cache) => {
            cache.put('/index.html', copy);
          });
          return response;
        })
        .catch(() => {
          // If offline, serve the cached index.html
          return caches.match('/index.html');
        })
    );
    return;
  }

  // For static assets, API calls, and local JSON resources, use Stale-While-Revalidate
  event.respondWith(
    caches.match(request).then((cachedResponse) => {
      const fetchPromise = fetch(request)
        .then((networkResponse) => {
          // Check if valid response to avoid caching errors
          if (networkResponse && networkResponse.status === 200) {
            const copy = networkResponse.clone();
            caches.open(CACHE_NAME).then((cache) => {
              cache.put(request, copy);
            });
          }
          return networkResponse;
        })
        .catch((err) => {
          console.warn('[Service Worker] Fetch failed, serving from cache:', request.url, err);
          return cachedResponse;
        });

      // Return cached response immediately if available, otherwise wait for network
      return cachedResponse || fetchPromise;
    })
  );
});
