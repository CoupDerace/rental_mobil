import os
import glob
import re

base_dir = r'c:\Users\Asus\rental_mobil\lib\features'
files = glob.glob(base_dir + '/**/*_page.dart', recursive=True)

for file in files:
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if ElevatedButton.icon is in the file
    if 'ElevatedButton.icon(' in content and 'Tambah' in content and '_showAddDialog' in content:
        # Extract the label name (e.g. Tambah Pelanggan)
        label_match = re.search(r'label:\s*const\s*Text\(\"(Tambah.*?)\"\),', content)
        if not label_match:
            continue
        label_name = label_match.group(1)
        
        # Check if isAdmin is used
        is_admin_check = 'if (isAdmin)' in content
        
        fab_code = f'''floatingActionButton: {'isAdmin ? ' if is_admin_check else ''}FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text(\"{label_name}\"),
              backgroundColor: const Color(0xFFFF7A1A),
              foregroundColor: Colors.white,
            ){' : null' if is_admin_check else ''},'''
            
        # Insert FAB into AppScaffold
        if 'floatingActionButton:' not in content:
            content = re.sub(
                r'(AppScaffold\(\s*title:\s*[^,]+,)',
                r'\1\n            ' + fab_code,
                content,
                count=1
            )
            
        # Remove the ElevatedButton section
        if is_admin_check:
            content = re.sub(
                r'if\s*\(isAdmin\)\s*ElevatedButton\.icon\([^)]+onPressed:\s*\(\)\s*=>\s*_showAddDialog\(context,\s*provider\),\s*\),?',
                r'',
                content,
                flags=re.DOTALL
            )
        else:
            content = re.sub(
                r'ElevatedButton\.icon\([^)]+onPressed:\s*\(\)\s*=>\s*_showAddDialog\(context,\s*provider\),\s*\),?',
                r'',
                content,
                flags=re.DOTALL
            )
            
        with open(file, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f'Updated {file}')
