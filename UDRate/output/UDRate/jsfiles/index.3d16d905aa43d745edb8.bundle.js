var udrate=function(t){var e={};function r(n){if(e[n])return e[n].exports;var o=e[n]={i:n,l:!1,exports:{}};return t[n].call(o.exports,o,o.exports,r),o.l=!0,o.exports}return r.m=t,r.c=e,r.d=function(t,e,n){r.o(t,e)||Object.defineProperty(t,e,{enumerable:!0,get:n})},r.r=function(t){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(t,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(t,"__esModule",{value:!0})},r.t=function(t,e){if(1&e&&(t=r(t)),8&e)return t;if(4&e&&"object"==typeof t&&t&&t.__esModule)return t;var n=Object.create(null);if(r.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:t}),2&e&&"string"!=typeof t)for(var o in t)r.d(n,o,function(e){return t[e]}.bind(null,o));return n},r.n=function(t){var e=t&&t.__esModule?function(){return t.default}:function(){return t};return r.d(e,"a",e),e},r.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},r.p="/",r(r.s=1)}([function(t,e){t.exports=react},function(t,e,r){"use strict";r.r(e);var n=r(0),o=r.n(n),a=function(t){var e=t.selected,r=t.activeColor,n=t.inactiveColor,a=t.size;return o.a.createElement("svg",{style:{color:e?r:n,fill:e?"rgba(0, 0, 0, 0.02)":"rgba(0, 0, 0, 0.04)",display:"block",height:a,width:a,transition:"color 0.5s ease-in-out, fill 0.5s ease-in-out"},xmlns:"http://www.w3.org/2000/svg",viewBox:"0 0 36 34"},o.a.createElement("path",{fill:"currentColor",d:"M19.6859343,0.861782958 L24.8136328,8.05088572 C25.0669318,8.40601432 25.4299179,8.6717536 25.8489524,8.80883508 L34.592052,11.6690221 C35.6704701,12.021812 36.2532905,13.1657829 35.8938178,14.2241526 C35.8056709,14.4836775 35.6647294,14.7229267 35.4795411,14.9273903 L29.901129,21.0864353 C29.5299163,21.4962859 29.3444371,22.0366367 29.3872912,22.5833831 L30.1116131,31.8245163 C30.1987981,32.9368499 29.3506698,33.9079379 28.2172657,33.993502 C27.9437428,34.0141511 27.6687736,33.9809301 27.4085205,33.8957918 L18.6506147,31.0307612 C18.2281197,30.8925477 17.7713439,30.8925477 17.3488489,31.0307612 L8.59094317,33.8957918 C7.51252508,34.2485817 6.34688429,33.6765963 5.98741159,32.6182265 C5.90066055,32.3628116 5.86681029,32.0929542 5.88785051,31.8245163 L6.61217242,22.5833831 C6.65502653,22.0366367 6.46954737,21.4962859 6.09833466,21.0864353 L0.519922484,14.9273903 C-0.235294755,14.0935658 -0.158766688,12.8167745 0.690852706,12.0755971 C0.899189467,11.8938516 1.14297067,11.7555303 1.40741159,11.6690221 L10.1505113,8.80883508 C10.5695458,8.6717536 10.9325319,8.40601432 11.1858308,8.05088572 L16.3135293,0.861782958 C16.9654141,-0.0521682813 18.2488096,-0.274439442 19.1800736,0.365326425 C19.3769294,0.500563797 19.5481352,0.668586713 19.6859343,0.861782958 Z"}))},i="#121621",c="#FFED76",u=function(t){var e=t.maxStars,r=void 0===e?5:e,n=t.value,u=void 0===n?0:n,l=t.onChange,s=t.activeColor,f=void 0===s?c:s,b=t.inactiveColor,p=void 0===b?i:b,y=t.size,v=void 0===y?36:y,d=t.editable,m=void 0===d||d;return o.a.createElement("ul",{style:{color:p,margin:0,padding:0,listStyle:"none",display:"flex"}},Array(r).fill(null).map((function(t,e){return e+1})).map((function(t){return o.a.createElement("li",{title:t+" star",key:t,onClick:function(){l&&m&&l(t)},style:{cursor:"pointer",position:"relative",marginRight:t!==r?16:0}},o.a.createElement(a,{selected:t<=u,activeColor:f,inactiveColor:p,size:v}))})))};function l(t){return function(t){if(Array.isArray(t)){for(var e=0,r=new Array(t.length);e<t.length;e++)r[e]=t[e];return r}}(t)||function(t){if(Symbol.iterator in Object(t)||"[object Arguments]"===Object.prototype.toString.call(t))return Array.from(t)}(t)||function(){throw new TypeError("Invalid attempt to spread non-iterable instance")}()}function s(t,e){var r=Object.keys(t);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(t);e&&(n=n.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),r.push.apply(r,n)}return r}function f(t){for(var e=1;e<arguments.length;e++){var r=null!=arguments[e]?arguments[e]:{};e%2?s(r,!0).forEach((function(e){b(t,e,r[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(r)):s(r).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(r,e))}))}return t}function b(t,e,r){return e in t?Object.defineProperty(t,e,{value:r,enumerable:!0,configurable:!0,writable:!0}):t[e]=r,t}function p(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){if(!(Symbol.iterator in Object(t)||"[object Arguments]"===Object.prototype.toString.call(t)))return;var r=[],n=!0,o=!1,a=void 0;try{for(var i,c=t[Symbol.iterator]();!(n=(i=c.next()).done)&&(r.push(i.value),!e||r.length!==e);n=!0);}catch(t){o=!0,a=t}finally{try{n||null==c.return||c.return()}finally{if(o)throw a}}return r}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}function y(t,e){if(null==t)return{};var r,n,o=function(t,e){if(null==t)return{};var r,n,o={},a=Object.keys(t);for(n=0;n<a.length;n++)r=a[n],e.indexOf(r)>=0||(o[r]=t[r]);return o}(t,e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(t);for(n=0;n<a.length;n++)r=a[n],e.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(t,r)&&(o[r]=t[r])}return o}var v="setState",d="requestState",m="removeElement",g="addElement",O="clearElement",h="syncElement";function j(){return(j=Object.assign||function(t){for(var e=1;e<arguments.length;e++){var r=arguments[e];for(var n in r)Object.prototype.hasOwnProperty.call(r,n)&&(t[n]=r[n])}return t}).apply(this,arguments)}function C(t,e){return function(t){if(Array.isArray(t))return t}(t)||function(t,e){if(!(Symbol.iterator in Object(t)||"[object Arguments]"===Object.prototype.toString.call(t)))return;var r=[],n=!0,o=!1,a=void 0;try{for(var i,c=t[Symbol.iterator]();!(n=(i=c.next()).done)&&(r.push(i.value),!e||r.length!==e);n=!0);}catch(t){o=!0,a=t}finally{try{n||null==c.return||c.return()}finally{if(o)throw a}}return r}(t,e)||function(){throw new TypeError("Invalid attempt to destructure non-iterable instance")}()}var w=function(t){var e=C(function(t,e){var r=e.content,o=y(e,["content"]),a=p(Object(n.useState)({content:r,attributes:o}),2),i=a[0],c=a[1];Object(n.useEffect)((function(){var e=UniversalDashboard.subscribe(t,u);return function(){return UniversalDashboard.unsubscribe(e)}}),[t,e]);var u=Object(n.useCallback)((function(t,e){switch(e.type){case v:c((function(t){return{attributes:f({},t.attributes,{},e.state.attributes),content:e.state.content?Array.isArray(e.state.content)?e.state.content:Array.from(e.state.content):[]}}));break;case d:UniversalDashboard.post("/api/internal/component/element/sessionState/".concat(e.requestId),f({},i));break;case g:c((function(t){return f({},t,{content:t.content.concat(e.elements)})}));break;case m:c((function(t){var e=t.content;return e.splice(-1,1),f({},t,{content:l(e)})}));break;case O:c((function(t){return f({},t,{content:[]})}));break;case h:s()}}),[event]),s=Object(n.useCallback)((function(){UniversalDashboard.get("/api/internal/component/element/".concat(t),(function(t){return c((function(e){return f({},e,{content:t})}))}))}),[t]);return[i,s,c]}(t.id,t),2),r=e[0],a=(e[1],r.content,r.attributes),i=C(Object(n.useState)(0),2),c=i[0],s=i[1];return o.a.createElement(u,j({},a,{value:c,onChange:function(t){a.hasCallBack&&s(t),UniversalDashboard.publish("element-event",{type:"clientEvent",eventId:a.id+"OnChange",eventName:"onChange",eventData:t.toString()})}}))};UniversalDashboard.register("ud-rate",w)}]);
//# sourceMappingURL=index.3d16d905aa43d745edb8.bundle.map