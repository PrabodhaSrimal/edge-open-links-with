const box = document.getElementById('rules');
const status = document.getElementById('status');
chrome.storage.sync.get({ rules: '' }, d => { box.value = d.rules; });
document.getElementById('save').onclick = () =>
  chrome.storage.sync.set({ rules: box.value }, () => { status.textContent = 'Saved.'; });
