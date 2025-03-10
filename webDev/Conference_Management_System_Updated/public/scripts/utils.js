export function hideAllSections() {
  const sections = document.getElementsByTagName('section');
  for (const section of sections) {
      section.style.display = 'none';
  }
}

export function showSection(sectionId) {
  hideAllSections();
  body.setAttribute('data-role', '');
  sessionStorage.removeItem('userRole');
  sessionStorage.removeItem('userEmail');
  document.getElementById(sectionId).style.display = 'block';
}