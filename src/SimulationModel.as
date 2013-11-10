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

        // view
        private var _physicBounds:Rectangle;

        private var _alertMessage:String;
        private var _alertMessageChanged:Signal;

        // simulation params
        private var _steps:int;
        private var _stepsChanged:Signal;

        private var _stepTime:Number;
        private var _stepTimeChanged:Signal;

        private var _targetPosition:Point;
        private var _targetPositionChanged:Signal;

        private var _velocity:Number;// initial velocity length
        private var _velocityChanged:Signal;

        private var _trajectory:int;
        private var _trajectoryChanged:Signal;

        // physic
        private var _gravity:Vec2;
        private var _space:Space;
        private var _body:Body;
        private var _launchVelocity:Vec2;

        public function SimulationModel(physic_bounds:Rectangle) {
            createPhysic(physic_bounds);
            resetPhysic();

            _stateChanged = new Signal();
            _velocityChanged = new Signal();
            _stepsChanged = new Signal();
            _stepTimeChanged = new Signal();
            _targetPositionChanged = new Signal();
            _trajectoryChanged = new Signal();
            _alertMessageChanged = new Signal();

            _steps = 0;
            _stepTime = 1/30;
            _velocity = 0;
            _trajectory = 0;
            _alertMessage = "";
            _launchVelocity = new Vec2();
            _targetPosition = new Point();
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
        }

        public function calculateVelocity():void {
            var dt:Number = _stepTime;
            var px:Number = _targetPosition.x - _body.position.x;
            var py:Number = _targetPosition.y - _body.position.y;
            var gstep:Number = _gravity.y * dt * dt;

            _launchVelocity.x = (px / _steps) / dt;
            _launchVelocity.y = (py / _steps - 0.5 * (gstep * (_steps + 1))) / dt;
        }

        // setters

        public function set state(value:int):void {
            if (_state == STATE_LAUNCHED && value == STATE_AIM) {
                resetPhysic();
            }
            else if (_state == STATE_AIM && value == STATE_LAUNCHED) {
                _body.velocity.set(_launchVelocity);
            }

            _state = value;
            _stateChanged.dispatch();
        }

        public function set steps(value:int):void {
            _steps = value;
            _stepsChanged.dispatch();
        }

        public function set stepTime(value:Number):void {
            _stepTime = value;
            _stepTimeChanged.dispatch();
        }

        public function setTargetPosition(x:Number, y:Number):void {
            _targetPosition.setTo(x, y);
            _targetPositionChanged.dispatch();
        }

        public function set velocity(value:Number):void {
            _velocity = value;
            _velocityChanged.dispatch();
        }

        public function set trajectory(value:int):void {
            _trajectory = value;
            _trajectoryChanged.dispatch();
        }

        public function set alertMessage(value:String):void {
            _alertMessage = value;
            _alertMessageChanged.dispatch();
        }

        // getters

        public function get state():int {
            return _state;
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

        public function get physicBounds():Rectangle {
            return _physicBounds;
        }

        public function get stepsChanged():Signal {
            return _stepsChanged;
        }

        public function get stepTimeChanged():Signal {
            return _stepTimeChanged;
        }

        public function get targetPositionChanged():Signal {
            return _targetPositionChanged;
        }

        public function get velocity():Number {
            return _velocity;
        }

        public function get velocityChanged():Signal {
            return _velocityChanged;
        }

        public function get trajectory():int {
            return _trajectory;
        }

        public function get trajectoryChanged():Signal {
            return _trajectoryChanged;
        }

        public function get alertMessage():String {
            return _alertMessage;
        }

        public function get alertMessageChanged():Signal {
            return _alertMessageChanged;
        }
    }
}
