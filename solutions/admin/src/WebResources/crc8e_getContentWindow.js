// This script should be in the HTML web resource.
// No usage of Xrm or formContext should happen until this method is called.
function setClientApiContext(xrm, formContext) {
  // Optionally set Xrm and formContext as global variables on the page.
  window.Xrm = xrm;
  window._formContext = formContext;
   
  // Add script logic here that uses xrm or the formContext.
}
 
 
// This should be in a script loaded on the form.
// form_onload is a handler for the form onload event.
function form_onload(executionContext) {
  var formContext = executionContext.getFormContext();
  var wrControl = formContext.getControl("new_myWebResource.htm");
  if (wrControl) {
      wrControl.getContentWindow().then(
          function (contentWindow) {
              contentWindow.setClientApiContext(Xrm, formContext);
          }
      )
  }
}