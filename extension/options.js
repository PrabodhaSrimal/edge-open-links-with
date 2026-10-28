const box = document.getElementById('rules');
const status = document.getElementById('status');
chrome.storage.sync.get({ keep: '' }, d => { box.value = d.keep; });
document.getElementById('save').onclick = () =>
  chrome.storage.sync.set({ keep: box.value }, () => { status.textContent = 'Saved.'; });
