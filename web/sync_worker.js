// web/sync_worker.js

const SYNC_TAG = 'ecclesiaste-sync-tag';

// 1. Installation du Service Worker
self.addEventListener('install', event => {
    console.log('Service Worker pour la synchronisation installé.');
    // Force le nouveau service worker à devenir actif immédiatement.
    self.skipWaiting();
});

self.addEventListener('activate', event => {
    console.log('Service Worker activé.');
});

// 2. Écoute de l'événement de synchronisation périodique
self.addEventListener('periodicsync', (event) => {
    if (event.tag === SYNC_TAG) {
        console.log('Événement de synchronisation périodique reçu.');
        // Enveloppe la logique de synchronisation dans waitUntil pour que le SW ne soit pas terminé prématurément.
        event.waitUntil(triggerSyncInApp());
    }
});

// 3. Fonction pour communiquer avec l'application Flutter
async function triggerSyncInApp() {
    console.log('Tentative de communication avec l\'application Flutter pour la synchronisation...');

    // Récupère tous les clients (onglets) contrôlés par ce Service Worker.
    const clients = await self.clients.matchAll({
        includeUncontrolled: true,
        type: 'window',
    });

    if (clients && clients.length) {
        // Envoie un message au premier client trouvé (l'onglet de l'app).
        clients[0].postMessage({ type: 'TRIGGER_SYNC' });
        console.log('Message de déclenchement de la synchronisation envoyé à l\'application.');
    } else {
        console.log('Aucun client applicatif trouvé. La synchronisation ne peut pas être déclenchée depuis le SW.');
        // Ici, on pourrait implémenter une logique de secours (ex: fetch direct depuis le SW)
        // si l'application est complètement fermée, mais cela complexifie la gestion des données.
    }
}