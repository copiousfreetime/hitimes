package hitimes;

import java.io.IOException;
import org.jruby.Ruby;
import org.jruby.runtime.load.Library;

public class HitimesService implements Library {
    public void load(final Ruby runtime, boolean wrap) throws IOException {
        Hitimes.createHitimes(runtime);
    }
}

