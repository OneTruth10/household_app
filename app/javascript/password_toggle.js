export function togglePasswordVisibility(input, passwordVisibleIcon, passwordHiddenIcon) {
  if (input.type === 'password') {
    input.type = 'text';
    if (passwordVisibleIcon) passwordVisibleIcon.style.display = 'none';
    if (passwordHiddenIcon) passwordHiddenIcon.style.display = 'inline-block';
  } else {
    input.type = 'password';
    if (passwordVisibleIcon) passwordVisibleIcon.style.display = 'inline-block';
    if (passwordHiddenIcon) passwordHiddenIcon.style.display = 'none';
  }
}