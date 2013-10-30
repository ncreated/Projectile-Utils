package {

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.getTimer;

    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.shape.Polygon;

    import nape.space.Space;
    import nape.util.BitmapDebug;
    import nape.util.Debug;

    [SWF(width="640", height="480", frameRate="30", backgroundColor="000000")]
    public class PhysicTrajectoryPredict extends Sprite {

        private var STATE_AIM:int = 0;
        private var STATE_LAUNCHED:int = 1;
        private var _state:int;

        private var _n:Number;

        private var _gravity:Vec2;
        private var _debug:Debug;
        private var _path:Sprite;

        private var _space:Space;

        private var _launchVelocity:Vec2;
        private var _body:Body;

        public function PhysicTrajectoryPredict() {
            addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);

            var sp:SettingsPanel = new SettingsPanel();
            sp.x = 100;
            sp.y = 100;
            addChild(sp);
        }

        private function init(event:Event):void {
            _debug = new BitmapDebug(stage.stageWidth, stage.stageHeight, 0x000000, false);
            addChild(_debug.display);

            _path = new Sprite();
            addChild(_path);

            _n = 60;//120;
            _gravity = new Vec2(0, 200);
            _space = new Space(_gravity);

            _body = new Body(BodyType.DYNAMIC);
            _body.shapes.add(new Polygon(Polygon.box(10, 10)));
            _body.space = _space;

            // platform
            var platform:Body = new Body(BodyType.STATIC, new Vec2(100, 300));
            platform.shapes.add(new Polygon(Polygon.box(30, 6)));
            platform.space = _space;

            // draw floor
            var floor:Body = new Body(BodyType.STATIC);
            floor.shapes.add(new Polygon(Polygon.rect(0, stage.height - 5, stage.width, 1)));
            floor.space = _space;

            _path.addEventListener(Event.ENTER_FRAME, update, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_DOWN, clicked, false, 0, true);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, moved, false, 0, true);
            _previousUpdateTime = getTimer();

            _state = STATE_AIM;
            reset();
        }

        private function reset():void {
            _body.position = new Vec2(100, 292);
            _body.velocity = new Vec2(0, 0);
            _launchVelocity = new Vec2(0, 0);
        }

        private function clicked(event:MouseEvent):void {
            if (_state == STATE_AIM) {
                _body.velocity = _launchVelocity;
                _state = STATE_LAUNCHED;
            }
            else if (_state == STATE_LAUNCHED) {
                reset();
                _state = STATE_AIM;

            }
        }

        private function moved(event:MouseEvent):void {
            if (_state == STATE_AIM) {
                var dt:Number = 1/30;
                var px:Number = mouseX - _body.position.x;
                var py:Number = mouseY - _body.position.y;
                var gstep:Number = _gravity.y * dt * dt;

                _launchVelocity.x = (px / _n) / dt;
                _launchVelocity.y = (py / _n - 0.5 * (gstep * (_n + 1))) / dt;
            }
            else if (_state == STATE_LAUNCHED) {
            }
        }

        private var _previousUpdateTime:Number;
        private function update(event:Event):void {
            var temp:Number = _previousUpdateTime;
            _previousUpdateTime = getTimer();
            var frameTime: Number = Math.min(1/30, (_previousUpdateTime - temp)/1000);

            _space.step(frameTime);
            _debug.clear();
            _debug.draw(_space);
            _debug.flush();

            if (_state == STATE_AIM) {
                _path.graphics.clear();
                _path.graphics.lineStyle(2, 0xEFEF39, 0.3);
                _path.graphics.moveTo(_body.position.x, _body.position.y);

                var point:Vec2;
                for (var i:int = 0; i < _n; i++) {
                    point = getTrajectoryPoint(_body.position, _launchVelocity, i);
                    _path.graphics.lineTo(point.x, point.y);
                }
            }
        }

        private function getTrajectoryPoint(begin:Vec2, velocity:Vec2, n:int):Vec2 {
            var dt:Number = 1/30;
            var stepVelocity:Vec2 = velocity.mul(dt);
            var stepGravity:Vec2 = _gravity.mul(dt * dt);

            var c2:Vec2 = stepVelocity.mul(n);
            var c3:Vec2 = stepGravity.mul((n * n + n) * 0.5);

            return begin.add(c2).add(c3);
        }
    }
}
