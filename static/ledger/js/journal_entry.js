// === FORMATTER ANGKA RIBUAN INDONESIA ===
function formatNumber(input) {
    const start = input.selectionStart;
    let value = input.value.replace(/\D/g, '');
    if (value === '') {
        input.value = '';
        updateTotals();
        return;
    }
    input.value = parseInt(value, 10).toLocaleString('id-ID');
    input.setSelectionRange(input.value.length, input.value.length);
    updateTotals();
}

function parseNumber(value) {
    return parseInt((value || '0').replace(/\./g, ''), 10) || 0;
}

// === FUNGSI MODAL DIMENSI ANALITIS ===
let activeRowForDimensions = null;

function openDimensionModal(btn) {
    activeRowForDimensions = btn.closest('tr');
    if (!activeRowForDimensions) return;

    const getVal = (cls) => {
        const el = activeRowForDimensions.querySelector(cls);
        return el ? el.value : '';
    };

    document.getElementById('modal_cost_center').value = getVal('.dim-cost-center');
    document.getElementById('modal_profit_center').value = getVal('.dim-profit-center');
    document.getElementById('modal_project').value = getVal('.dim-project');
    document.getElementById('modal_activity').value = getVal('.dim-activity');
    document.getElementById('modal_location').value = getVal('.dim-location');
    document.getElementById('modal_partner').value = getVal('.dim-partner');
    document.getElementById('modal_product').value = getVal('.dim-product');

    const modal = document.getElementById('dimensionModal');
    if (modal) {
        modal.style.display = 'flex';
        void modal.offsetWidth; // Force CSS repaint
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }
}

function closeDimensionModal() {
    const modal = document.getElementById('dimensionModal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = '';
        setTimeout(() => {
            if (!modal.classList.contains('active')) {
                modal.style.display = 'none';
            }
        }, 250);
    }
    activeRowForDimensions = null;
}

function clearDimensionModal() {
    document.getElementById('modal_cost_center').value = '';
    document.getElementById('modal_profit_center').value = '';
    document.getElementById('modal_project').value = '';
    document.getElementById('modal_activity').value = '';
    document.getElementById('modal_location').value = '';
    document.getElementById('modal_partner').value = '';
    document.getElementById('modal_product').value = '';
    saveDimensionModal();
}

function saveDimensionModal() {
    if (!activeRowForDimensions) return;

    const setVal = (cls, val) => {
        const el = activeRowForDimensions.querySelector(cls);
        if (el) el.value = val;
    };

    setVal('.dim-cost-center', document.getElementById('modal_cost_center').value);
    setVal('.dim-profit-center', document.getElementById('modal_profit_center').value);
    setVal('.dim-project', document.getElementById('modal_project').value);
    setVal('.dim-activity', document.getElementById('modal_activity').value);
    setVal('.dim-location', document.getElementById('modal_location').value);
    setVal('.dim-partner', document.getElementById('modal_partner').value);
    setVal('.dim-product', document.getElementById('modal_product').value);

    updateRowDimensionBadge(activeRowForDimensions);
    closeDimensionModal();
}

function updateRowDimensionBadge(row) {
    if (!row) return;

    const getVal = (cls) => {
        const el = row.querySelector(cls);
        return el ? el.value.trim() : '';
    };

    const values = [
        getVal('.dim-cost-center'),
        getVal('.dim-profit-center'),
        getVal('.dim-project'),
        getVal('.dim-activity'),
        getVal('.dim-location'),
        getVal('.dim-partner'),
        getVal('.dim-product')
    ].filter(v => v !== '');

    const btn = row.querySelector('.btn-dim');
    if (!btn) return;

    if (values.length > 0) {
        btn.classList.add('has-value');
        btn.innerHTML = `<span>🏷️ ${values.length} Terisi</span>`;
        btn.title = `${values.length} dimensi dipilih`;
    } else {
        btn.classList.remove('has-value');
        btn.innerHTML = `<span>⚙️ Atur Dimensi</span>`;
        btn.title = 'Klik untuk memilih dimensi analitis';
    }
}

// === FUNGSI TAMBAH / HAPUS BARIS JURNAL ===
function addEntry() {
    const tableBody = document.getElementById('entries');
    const firstRow = document.querySelector('.entry');
    if (!firstRow || !tableBody) return;

    const row = firstRow.cloneNode(true);

    // Reset input teks/angka & hidden dimensi
    row.querySelectorAll('input').forEach(input => {
        input.value = '';
    });

    // Reset dropdown akun
    const accSelect = row.querySelector('select[name="account_id[]"]');
    if (accSelect) accSelect.selectedIndex = 0;

    // Reset badge dimensi
    updateRowDimensionBadge(row);

    // Event listener untuk debit & kredit
    const debitInput = row.querySelector('input[name="debit[]"]');
    const creditInput = row.querySelector('input[name="credit[]"]');

    if (debitInput) {
        debitInput.addEventListener('input', () => formatNumber(debitInput));
    }
    if (creditInput) {
        creditInput.addEventListener('input', () => formatNumber(creditInput));
    }

    // Tombol hapus
    const removeButton = row.querySelector('.btn-remove, button[type="button"]:not(.btn-dim)');
    if (removeButton) {
        removeButton.onclick = function () {
            removeEntry(this);
        };
    }

    tableBody.appendChild(row);
    updateTotals();
}

function removeEntry(button) {
    const row = button.closest('tr');
    const rows = document.querySelectorAll('#entries .entry, tbody tr.entry');

    if (rows.length > 1) {
        row.remove();
        updateTotals();
    } else {
        alert('Minimal satu baris jurnal diperlukan.');
    }
}

function updateTotals() {
    const debits = document.querySelectorAll('input[name="debit[]"]');
    const credits = document.querySelectorAll('input[name="credit[]"]');

    let totalDebit = 0, totalCredit = 0;

    debits.forEach(input => {
        totalDebit += parseNumber(input.value);
    });
    credits.forEach(input => {
        totalCredit += parseNumber(input.value);
    });

    const totalDebitEl = document.getElementById('total-debit');
    const totalCreditEl = document.getElementById('total-credit');
    if (totalDebitEl) totalDebitEl.innerText = totalDebit.toLocaleString('id-ID');
    if (totalCreditEl) totalCreditEl.innerText = totalCredit.toLocaleString('id-ID');

    const warning = document.getElementById('balance-warning');
    if (warning) {
        if (totalDebit !== totalCredit) {
            warning.style.display = 'block';
        } else {
            warning.style.display = 'none';
        }
    }
}

function validateJournal() {
    const totalDebit = parseNumber(document.getElementById('total-debit').innerText);
    const totalCredit = parseNumber(document.getElementById('total-credit').innerText);

    if (totalDebit !== totalCredit) {
        alert('Total debit dan kredit harus seimbang!');
        return false;
    }

    document.querySelectorAll('input[name="debit[]"], input[name="credit[]"]').forEach(input => {
        input.value = parseNumber(input.value);
    });

    return true;
}

// Inisialisasi awal saat halaman siap
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('input[name="debit[]"]').forEach(input => {
        input.addEventListener('input', () => formatNumber(input));
    });
    document.querySelectorAll('input[name="credit[]"]').forEach(input => {
        input.addEventListener('input', () => formatNumber(input));
    });

    document.querySelectorAll('#entries tr.entry, tbody tr.entry, tbody tr').forEach(row => {
        updateRowDimensionBadge(row);
    });

    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            closeDimensionModal();
        }
    });

    updateTotals();
});
