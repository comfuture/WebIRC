(function($){
	$.Class = function(code){
		var klass = function() {
			var instance = (arguments[0] !== null && this.__init__ && typeof this.__init__ == 'function')
				? this.__init__.apply(this, arguments)
				: this;
			return instance;
		};
		$.extend(klass, this);
		$.extend(klass.prototype, {
			'bind': function(type, fn) {
				this.__events__ = this.__events__ || {};
				this.__events__[type] = this.__events__[type] || [];
				this.__events__[type].push(fn);
				return this;
			},

			'unbind': function(type, fn) {
				if (this.__events__ && this.__events__[type]) {
					this.__events__[type].splice(this.__events__[type].indexOf(fn), 1);
				}
				return this;
			},

			'trigger': function(type, args){
				if (this.__events__ && this.__events__[type]){
					var evt = $.Event(type);
					evt.target = this;
					$.each(this.__events__[type], function(idx, fn) {
						fn.apply(this, $.merge([evt], args || []));
					});
				}
				return this;
			}
		}, code);

		klass.constructor = $.Class;
		return klass;
	};

	var merge = function(previous, current){
		if (previous && previous != current){
			var type = typeof current;
			if (type != typeof previous) return current;
			switch(type){
				case 'function':
					var merged = function(){
						this.parent = arguments.callee.parent;
						return current.apply(this, arguments);
					};
					merged.parent = previous;
					return merged;
				case 'object': return $.merge(previous, current);
			}
		}
		return current;
	};

	$.extend(true, $.Class.prototype, {
		'extend': function(properties) {
			var proto = new this(null);
			for (var property in properties){
				var pp = proto[property];
				proto[property] = merge(pp, properties[property]);
			}
			return new $.Class(proto);
		},

		'implement': function() {
			for (var i = 0, l = arguments.length; i < l; i++) $.extend(this.prototype, arguments[i]);
		}
	});

	// convenient shortcut
	window.Class = function(code) {
		return new $.Class(code);
	};

})(jQuery);