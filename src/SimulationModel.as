package {
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.shape.Polygon;
    import nape.space.Space;

    import org.osflash.signals.Signal;

    /**
     *
     * @author maciek grzybowski, 30.10.2013 23:55
     *
     */
    public class SimulationModel {

        public static const STATE_AIM:int = 0;
        public static const STATE_LAUNCHED:int = 1;
        private var _state:int = STATE_AIM;
        private var _stateChanged:Signal;

        public static const MODE_ADJUST_ANGLE:int = 0;
        public static const MODE_ADJUST_VELOCITY:int = 1;
        private var _mode:int = MODE_ADJUST_VELOCITY;
        private var _modeChanged:Signal;


        // view
        private var _physicBounds:Rectangle;

        // simulation params
        private var _steps:int;
        private var _stepsChanged:Signal;

        private var _stepTime:Number;
        private var _targetPosition:Point;

        // physic
        private var _gravity:Vec2;
        private var _space:Space;
        private var _body:Body;
        private var _launchVelocity:Vec2;

        public function SimulationModel(physic_bounds:Rectangle) {
            createPhysic(physic_bounds);
            resetPhysic();

            _stateChanged = new Signal(int);
            _modeChanged = new Signal(int);
            _stepsChanged = new Signal(int);

            _steps = 70;
            _stepTime = 1/30;
            _targetPosition = new Point(350, 100);
            _physicBounds = physic_bounds;
        }

        private function createPhysic(bounds:Rectangle):void {
            _gravity = new Vec2(0, 200);
            _space = new Space(_gravity);

            _body = new Body(BodyType.DYNAMIC);
            _body.shapes.add(new Polygon(Polygon.box(10, 10)));
            _body.space = _space;

            // platform
            var platform:Body = new Body(BodyType.STATIC, new Vec2(100, 250));
            platform.shapes.add(new Polygon(Polygon.box(30, 6)));
            platform.space = _space;

            // floor
            var floor:Body = new Body(BodyType.STATIC);
            floor.shapes.add(new Polygon(Polygon.rect(0, bounds.height - 11, bounds.width, 10)));
            floor.space = _space;

        }

        private function resetPhysic():void {
            _body.position = new Vec2(100, 242);
            _body.velocity = new Vec2(0, 0);
            _launchVelocity = new Vec2(0, 0);
        }

        public function calculateVelocity():void {
            var dt:Number = _stepTime;
            var px:Number = _targetPosition.x - _body.position.x;
            var py:Number = _targetPosition.y - _body.position.y;
            var gstep:Number = _gravity.y * dt * dt;

            _launchVelocity.x = (px / _steps) / dt;
            _launchVelocity.y = (py / _steps - 0.5 * (gstep * (_steps + 1))) / dt;
        }

        public function calculateAngle():void {
            var dt:Number = _stepTime;
            var sx:Number = _targetPosition.x - _body.position.x;
            var sy:Number = (_targetPosition.y - _body.position.y);
            var g:Number = _gravity.y;
            var v:Number = 200;

            var l:Number = v * v * v * v - g * (g * sx * sx + 2 * sy * v * v);
            var delta:Number = Math.sqrt(l);
            var angle1:Number = Math.atan((v * v - delta)/(g * sx));
            var angle2:Number = Math.atan((v * v + delta)/(g * sx));

            steps = 200;
            _launchVelocity.x = Math.cos(angle1) * v;
            _launchVelocity.y = Math.sin(angle1) * v;

//            _launchVelocity.x = (px / _steps) / dt;
//            _launchVelocity.y = (py / _steps - 0.5 * (gstep * (_steps + 1))) / dt;
//            _launchVelocity.x = 10;
//            _launchVelocity.y = -300;

//            steps = (-gstep - 2 * _launchVelocity.y) / gstep;
        }

        // setters

        public function set state(value:int):void {
            if (_state == STATE_LAUNCHED && value == STATE_AIM) {
                resetPhysic();
            }
            else if (_state == STATE_AIM && value == STATE_LAUNCHED) {
                _body.velocity = _launchVelocity;
            }

            _state = value;
            _stateChanged.dispatch(value);
        }

        public function set mode(value:int):void {
            _mode = value;
            _modeChanged.dispatch(value);
        }

        public function set steps(value:int):void {
            _steps = value;
            _stepsChanged.dispatch(value);
        }

        public function set stepTime(value:Number):void {
            _stepTime = value;
        }

        // getters

        public function get state():int {
            return _state;
        }

        public function get mode():int {
            return _mode;
        }

        public function get gravity():Vec2 {
            return _gravity;
        }

        public function get space():Space {
            return _space;
        }

        public function get body():Body {
            return _body;
        }

        public function get launchVelocity():Vec2 {
            return _launchVelocity;
        }

        public function get steps():int {
            return _steps;
        }

        public function get stepTime():Number {
            return _stepTime;
        }

        public function get targetPosition():Point {
            return _targetPosition;
        }

        public function get stateChanged():Signal {
            return _stateChanged;
        }

        public function get modeChanged():Signal {
            return _modeChanged;
        }

        public function get physicBounds():Rectangle {
            return _physicBounds;
        }

        public function get stepsChanged():Signal {
            return _stepsChanged;
        }
    }
}
