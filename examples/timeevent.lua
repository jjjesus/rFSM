--
-- Simple timeevent demo that shows how to write portable FSM.
--

require "rfsm"
require "rfsm_timeevent"

if rtt then
   require "rttlib"
   gettime = rtt.getTime
   print("using RTT timing services")
else
   if pcall(require, "rtp") then
      function gettime() return rtp.clock.gettime("CLOCK_MONOTONIC") end
      print("using rtp timing services")
   else
      print("falling back on low resolution Lua time")
      function gettime() return os.time(), 0 end
   end
end

rfsm_timeevent.set_gettime_hook(gettime)

return rfsm.csta {
   -- only for rfsm-sim
   dbg=true,
   idle_hook=function() uml(); os.execute("sleep 0.5") end,

   one = rfsm.sista{},
   two = rfsm.sista{},
   three = rfsm.sista{},
   four = rfsm.sista{},
   five = rfsm.sista{},

   rfsm.trans{ src='initial', tgt='one' },
   rfsm.trans{ src='one', tgt='two', events={ 'e_after(1)' } },
   rfsm.trans{ src='two', tgt='three', events={ 'e_after(1.5)' } },
   rfsm.trans{ src='three', tgt='four', events={ 'e_after(2)' } },
   rfsm.trans{ src='four', tgt='five', events={ 'e_after(3)' } },
   rfsm.trans{ src='five', tgt='one', events={ 'e_after(4.5)' } },
}

