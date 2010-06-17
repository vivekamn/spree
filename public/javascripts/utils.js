var agent				= navigator.appName;
var is_ie				= (agent.indexOf("Microsoft Internet Explorer") != -1)?true:false;

/**
 * Returns offset of an element relative to the document body.
 *
 * @private
 * @param {object} objElement Element object
 * @return Offset: left or x - left offset; top or y - top offset
 * @object
 */
getElementOffset = function(objElement) {
  var iLeft = iTop = 0;
  if (objElement.offsetParent) {
    var objParentPos = getElementOffset(objElement.offsetParent);
    iLeft = objParentPos.left + objElement.offsetLeft;
    iTop = objParentPos.top + objElement.offsetTop;
  }
  return {left: iLeft, top: iTop, x: iLeft, y: iTop};
};

/**
 * Returns offset of content of a scrollable element relative to the document
 * body. Offset is calulated as offset of an element minus scrollLeft/scrollTop
 * value.
 *
 * @private
 * @param {object} objElement Element object
 * @return Offset: left or x - left offset; top or y - top offset
 * @object
 */
getElementOffsetScrollable = function(objElement) {
  var objPos = getElementOffset(objElement);
  var iLeft = objPos.left;
  if (objElement.scrollLeft) {
    iLeft -= objElement.scrollLeft;
  }
  var iTop = objPos.top;
  if (objElement.scrollTop) {
    iTop -= objElement.scrollTop;
  }
  return {left: iLeft, top: iTop, x: iLeft, y: iTop};
};


getMousePos = function(objEvent) {
  var objPos = {
    pageX: 0,
    pageY: 0,
    clientX: 0,
    clientY: 0
  };
  var boolIsPageX = (typeof objEvent.pageX != 'undefined');
  var boolIsClientX = (typeof objEvent.clientX != 'undefined');
  objEvent || (objEvent = window.event);
  if (objEvent && (boolIsPageX || boolIsClientX)) {
    if (boolIsPageX) {
      objPos.pageX = objEvent.pageX;
      objPos.pageY = objEvent.pageY;
    } else {
      objPos.pageX = objEvent.clientX + getPageScrollX();
      objPos.pageY = objEvent.clientY + getPageScrollY();
    }
    if (boolIsClientX) {
      objPos.clientX = objEvent.clientX;
      objPos.clientY = objEvent.clientY;
    } else {
      objPos.clientX = objEvent.pageX - getPageScrollX();
      objPos.clientY = objEvent.pageY - getPageScrollY();
    }
  }
  return objPos;
};

getPageScrollY = function() {
	return window.pageYOffset ||
			document.documentElement.scrollTop ||
			(document.body ? document.body.scrollTop : 0) ||
			0;
};

/**
 * A generic Utils function that returns the current scroll position.
 *
 */
getPageScrollX = function() {
	return window.pageXOffset ||
			document.documentElement.scrollLeft ||
			(document.body ? document.body.scrollLeft : 0) ||
			0;
};


